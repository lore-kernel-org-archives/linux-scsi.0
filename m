From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter
 disable_eedp to Disable EEDP Support
Date: Wed, 19 Mar 2014 15:21:11 -0700
Message-ID: <1395267671.2185.63.camel@dabdike.int.hansenpartnership.com>
References: <20140314153622.GA7947@lsi.com>
	 <yq1r464wm7s.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1r464wm7s.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>, jejb@kernel.org, linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, linux-kernel@vger.kernel.org, sreekanthreddy0547@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-03-14 at 16:37 -0400, Martin K. Petersen wrote:
> >>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@lsi.com> writes:
> 
> Sreekanth> A new mpt2sas driver module parameter 'disable_eedp' is added
> Sreekanth> to Disable EEDP support. By default DIF support is enabled in
> Sreekanth> the driver and this module parameter would allow users to
> Sreekanth> turn it off.
> 
> Why don't you just set the prot_mask module parameter to 0?

Is there an answer to this?  It's holding up your patch submission.

James
