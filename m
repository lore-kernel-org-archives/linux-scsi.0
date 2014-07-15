From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 2/8][SCSI]mpt3sas: Clear PFA Status on SGPIO when PFA Drive is Removed or Replaced
Date: Tue, 15 Jul 2014 12:53:31 -0400
Message-ID: <yq1vbqyva0k.fsf@sermon.lab.mkp.net>
References: <20140625103930.GA13003@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140625103930.GA13003@avagotech.com> (Sreekanth Reddy's message
	of "Wed, 25 Jun 2014 16:09:30 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Cc: jejb@kernel.org, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@avagotech.com> writes:

Sreekanth> Added code to send an SEP message that turns off the
Sreekanth> Predictive Failure LED when a drive is removed (if Predictive
Sreekanth> Failure LED was turned on).

Sreekanth> Added a new flag 'pfa_led_on' per device that tracks the
Sreekanth> status of Predictive Failure LED. When the drive is removed,
Sreekanth> this flag is checked and sends an SEP message to turn off the
Sreekanth> respective Predictive Failure LED.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
