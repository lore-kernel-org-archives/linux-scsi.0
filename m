From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/22] [SCSI] mpt2sas, mpt3sas: Added support to log message when Temperature Threshold exceeds for any Sensor
Date: Wed, 03 Dec 2014 21:55:05 -0500
Message-ID: <yq1vblsi0om.fsf@sermon.lab.mkp.net>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-3-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416467155-16869-3-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Thu, 20 Nov 2014 12:35:35 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> This patch will log a message when driver receives
Sreekanth> "Temperature Threshold exceeded" event from any temperature
Sreekanth> sensor.  The message will look similar to like mpt3sas0:
Sreekanth> Temperature Threshold flags a b c d exceeded for Sensor: x
Sreekanth> !!!  mpt3sas0: Current Temp In Celsius: y

Sreekanth> where a b c d are threshold flags 0 1 2 3

Changes look fine. However, I'm a bit concerned about the unbounded
nature of this. What prevents the log from being flooded with
temperature warnings?

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
