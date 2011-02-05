From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over
 10GbE?
Date: Sat, 5 Feb 2011 14:54:36 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1102051451520.8518@p34.internal.lan>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <1296934967.2599.2.camel@jeff-ubuntu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1296934967.2599.2.camel@jeff-ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
To: Jean Gobin <jf@gobinjf.be>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org



On Sat, 5 Feb 2011, Jean Gobin wrote:

> Hi Justin,
>
> When you run the copy over the network, could you issue a "vmstat 1" on
> both machines?
>
> Thanks,
> J.

Hi,

Sure:

Server reading: (NFSD)
  0  8      0 3491300  19816 335144    0    0 166720     0 16994 31355  0  2 79 20  0
  0  9      0 3307132  19816 518392    0    0 183840     0 18893 33150  0  2 77 21  0
  0  9      0 2948104  19816 876748    0    0 358560     0 36059 63193  0  4 78 18  0
  3  3      0 2608568  19816 1216140    0    0 339008     0 34319 57289  0  3 80 17  0
  0  7      0 2271500  19816 1552364    0    0 336352     0 34622 54913  0  3 81 16  0
  0  5      0 2014760  19820 1808904    0    0 256320     4 27490 39669  0  2 82 15  0
  1 12      0 1935804   7648 1897868    0    0 245696     0 26247 37934  0  2 82 15  0
  3  7      0 1910924   7648 1923044    0    0 255232     0 27192 39606  0  3 82 15  0
  2 12      0 1882688   7648 1950252    0    0 297760     0 30942 47381  0  3 81 16  0
  3 13      0 1859100   7648 1975408    0    0 264480     0 27720 41203  0  3 82 15  0
  0 13      0 1835308   7648 1997980    0    0 255872     0 26953 40114  0  2 83 15  0

Server writing: (NFS)
  0  1      0 2963588  18460 858404    0    0     0     0 15461 24085  0  4 92  4  0
  0  1      0 2241844  18460 1568852    0    0     0 307522 30341 43566  0  7 90  2  0
  1  0      0 1958904   6792 1856808    0    0     0 348492 29154 49240  0  9 89  1  0
  2  0      0 1959028   6792 1856504    0    0     0 336152 28843 47120  0  9 90  1  0
  1  0      0 1958656   6792 1856892    0    0     0 258260 22357 34049  0  7 91  2  0
  0  1      0 1958576   4424 1858956    0    0     0 241876 20976 31781  0  7 91  2  0
  1  0      0 1958736   4428 1859184    0    0     0 262441 22843 34776  0  7 91  2  0
  1  0      0 1958600   4428 1858880    0    0     0 295685 25271 38730  0  8 90  2  0
  1  0      0 1958408   4428 1858916    0    0     0 262336 22351 32853  0  7 91  2  0
  2  0      0 1958660   4428 1858916    0    0     0 254172 21894 32753  0  7 91  2  0
  1  1      0 1958788   4428 1859972    0    0     0 286964 24219 36885  0  8 90

Justin.
