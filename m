From: Craig Tierney <ctierney@hpti.com>
Subject: Re: Performance
Date: Fri, 2 Aug 2002 08:16:55 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020802081655.B15152@hpti.com>
References: <20020802065548.87405.qmail@web14006.mail.yahoo.com> <20020802075037.66373.qmail@web14001.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020802075037.66373.qmail@web14001.mail.yahoo.com>; from mkotwani@yahoo.com on Fri, Aug 02, 2002 at 12:50:37AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Mukul Kotwani <mkotwani@yahoo.com>
Cc: linux-scsi@vger.kernel.org

For the Qlogic 2200F I am able to push 100 MB/s for
reads and writes using multiple threads to a filesystem
that is striped across mutliple host ports on the SAN.  Backend RAID is a 
Data Direct Networks SAN.  For a single thread to a ext3 filesystem
and 2.4.18, I get about 70 MB/s for reads and writes.

I have no Iops/sec numbers.

Craig


> Hello!
> Does anyone have any performace numbers of a Qlogic
> HBA? No of IOps/sec Max MBs /sec?
> 
> Thanks!
> M
> 
> 
> __________________________________________________
> Do You Yahoo!?
> Yahoo! Health - Feel better, live better
> http://health.yahoo.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Craig Tierney (ctierney@hpti.com)
