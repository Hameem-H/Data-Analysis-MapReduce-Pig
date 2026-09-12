import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class TopDriversRevenue {

    public static class Map extends Mapper<LongWritable, Text, Text, DoubleWritable> {
        private Text outKey = new Text();

        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            String[] f = value.toString().split(",");
            if (f.length < 11) return;

            outKey.set(f[1]); // driver_id
            double fare = Double.parseDouble(f[6]);

            context.write(outKey, new DoubleWritable(fare));
        }
    }

    public static class Reduce extends Reducer<Text, DoubleWritable, Text, DoubleWritable> {
        public void reduce(Text key, Iterable<DoubleWritable> values, Context context)
                throws IOException, InterruptedException {

            double sum = 0;
            for (DoubleWritable v : values) sum += v.get();

            context.write(key, new DoubleWritable(sum));
        }
    }

    public static void main(String[] args) throws Exception {
        Job job = Job.getInstance(new Configuration(), "Driver Revenue");

        job.setJarByClass(TopDriversRevenue.class);
        job.setMapperClass(Map.class);
        job.setReducerClass(Reduce.class);

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(DoubleWritable.class);

        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}