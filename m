From: David Dillow <dillowda@ornl.gov>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Thu, 31 Jan 2008 13:12:15 -0500
Message-ID: <1201803135.21160.8.camel@lap75545.ornl.gov>
References: <adazluoe2t3.fsf@cisco.com>
 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
 <20080130195635T.tomof@acm.org>
 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
 <e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com>
 <47A1EE54.6000005@vlnb.net> <47A1F67C.4020300@scalableinformatics.com>
 <e2e108260801310908k516f588cv51c18486b4a495d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934204AbYAaSM2@vger.kernel.org>
In-reply-to: <e2e108260801310908k516f588cv51c18486b4a495d2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: landman@scalableinformatics.com, Vladislav Bolkhovitin <vst@vlnb.net>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, rdreier@cisco.com, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, fujita.tomonori@lab.ntt.co.jp, scst-devel@lists.sourceforge.net, akpm@linux-foundation.org, FUJITA Tomonori <tomof@acm.org>, torvalds@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org


On Thu, 2008-01-31 at 18:08 +0100, Bart Van Assche wrote:
> If anyone has a suggestion for a better test than dd to compare the
> performance of SCSI storage protocols, please let it know.

xdd on /dev/sda, sdb, etc. using -dio to do direct IO seems to work
decently, though it is hard (ie, impossible) to get a repeatable
sequence of IO when using higher queue depths, as it uses threads to
generate multiple requests.

You may also look at sgpdd_survey from Lustre's iokit, but I've not done
much with that -- it uses the sg devices to send lowlevel SCSI commands.

I've been playing around with some benchmark code using libaio, but it's
not in generally usable shape.

xdd:
http://www.ioperformance.com/products.htm

Lustre IO Kit:
http://manual.lustre.org/manual/LustreManual16_HTML/DynamicHTML-20-1.html
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office
