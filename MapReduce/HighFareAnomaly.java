import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class HighFareAnomaly {

    public static class Map extends Mapper<LongWritable, Text, Text, DoubleWritable> {

        public void map(LongWritable key, Text value, Context context)
                throws IOException, InterruptedException {

            String[] f = value.toString().split(",");
            if (f.length < 11) return;

            double fare = Double.parseDouble(f[6]);
            double dist = Double.parseDouble(f[5]);

            if (dist == 0) return;

            double fpk = fare / dist;

            if (fpk > 50) { // threshold
                context.write(new Text(f[0]), new DoubleWritable(fpk));
            }
        }
    }

    public static void main(String[] args) throws Exception {
        Job job = Job.getInstance(new Configuration(), "High Fare Anomaly");

        job.setJarByClass(HighFareAnomaly.class);
        job.setMapperClass(Map.class);

        job.setNumReduceTasks(0); // map-only

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(DoubleWritable.class);

        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}