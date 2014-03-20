From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: [PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter
 disable_eedp to Disable EEDP Support
Date: Thu, 20 Mar 2014 13:25:00 +0000
Message-ID: <a13fdb6e86244cf886f992f1ec576f42@DM2PR07MB302.namprd07.prod.outlook.com>
References: <20140314153622.GA7947@lsi.com>
	 <yq1r464wm7s.fsf@sermon.lab.mkp.net>
 <1395267671.2185.63.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1395267671.2185.63.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "sreekanthreddy0547@gmail.com" <sreekanthreddy0547@gmail.com>
List-Id: linux-scsi@vger.kernel.org

>>
>> Sreekanth> A new mpt2sas driver module parameter 'disable_eedp' is
>> Sreekanth> added to Disable EEDP support. By default DIF support is
>> Sreekanth> enabled in the driver and this module parameter would allow
>> Sreekanth> users to turn it off.
>>
>> Why don't you just set the prot_mask module parameter to 0?
>
>Is there an answer to this?  It's holding up your patch submission.
>
>James
>


Hi Martin,

The prot_mask module parameter is defined for the purpose of setting the DIF and DIX capabilities. 
The disable_eedp module parameter is added with the intent to disable the complete EEDP related code and operations. This include even reading  manufacting pages to get EEDPTagMode etc. 
Agree that this could also be achieved using prot_mask. We are giving new parameter to be clear that we are disabling the complete EEDP.

Thanks,
Sreekanth
