From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter disable_eedp to Disable EEDP Support
Date: Fri, 14 Mar 2014 16:37:27 -0400
Message-ID: <yq1r464wm7s.fsf@sermon.lab.mkp.net>
References: <20140314153622.GA7947@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140314153622.GA7947@lsi.com> (Sreekanth Reddy's message of
	"Fri, 14 Mar 2014 21:06:22 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Cc: jejb@kernel.org, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, linux-kernel@vger.kernel.org, sreekanthreddy0547@gmail.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@lsi.com> writes:

Sreekanth> A new mpt2sas driver module parameter 'disable_eedp' is added
Sreekanth> to Disable EEDP support. By default DIF support is enabled in
Sreekanth> the driver and this module parameter would allow users to
Sreekanth> turn it off.

Why don't you just set the prot_mask module parameter to 0?

-- 
Martin K. Petersen	Oracle Linux Engineering
