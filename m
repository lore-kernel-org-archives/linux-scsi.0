From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: Time to make dynamically allocated devt the default for scsi
 disks?
Date: Mon, 15 Aug 2016 13:11:59 -0700
Message-ID: <27888438-c88d-d810-bcfc-1828dd61d593@sandisk.com>
References: <CAPcyv4jK8W52ss2FhJDa=95B_1q8Szv4AmH0f7p_jzyfEXv0Ag@mail.gmail.com>
 <1471047451.2407.95.camel@HansenPartnership.com>
 <CAPcyv4jqEaBY1atyrjG3G4PYOzaoLvAMfHgK1PD0Si=MRRwAuw@mail.gmail.com>
 <CAPcyv4i=85fCAm1A5Zh2+nYSw7vwXOD=i-B0g4m2eJ+XkEW3tw@mail.gmail.com>
 <1471101800.2397.9.camel@HansenPartnership.com>
 <CAPcyv4gDw49gZBO=Y+K9krgth68OUHcs8urGDNXiZzLNa6kotg@mail.gmail.com>
 <1471110212.2397.39.camel@HansenPartnership.com>
 <CAPcyv4gHq=RraHgcJGx_txk7YJHC8YQ3gCT4CHL0hvzsGpU1wg@mail.gmail.com>
 <1471195252.2355.18.camel@HansenPartnership.com>
 <CAPcyv4i4vyXc-qigqVo9oBL-7n9g4cbhK9Yt0o2F_bCPqMSF1Q@mail.gmail.com>
 <CAPcyv4j_R9CZKFXuv1EDqUOMTnAutyQwk_+h1pzC3NKyR6aGVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0054.outbound.protection.outlook.com ([104.47.42.54]:36241
	"EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932166AbcHOUMI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2016 16:12:08 -0400
In-Reply-To: <CAPcyv4j_R9CZKFXuv1EDqUOMTnAutyQwk_+h1pzC3NKyR6aGVQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Dave Hansen <dave.hansen@intel.com>

On 08/14/2016 11:23 AM, Dan Williams wrote:
> [ adding Bart back to the cc ]
>
> On Sun, Aug 14, 2016 at 11:08 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Sun, Aug 14, 2016 at 10:20 AM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
> [..]
>> I like it.  I still think the bdi registration code should be in
>> charge of taking the extra reference on the disk device's parent to
>> isolate / make clear why the extra reference is being acquired, but I
>> won't lose sleep if Jens takes your smaller change.
>>
>> Thanks James!
>
> Bart, do you have a test configuration already set up for this case.
> Can you give the 2 patches from James a try?
>
> https://patchwork.kernel.org/patch/9278201/
> https://patchwork.kernel.org/patch/9279513/

Hello Dan,

The "sysfs: cannot create duplicate filename" issue is something I ran 
into sporadically before I started using my patch that fixes this issue. 
I have not yet found a systematic way to trigger this behavior. Anyway, 
I will drop my patch and will start testing James' two patches. It will 
take a few days to test these patches thoroughly.

Bart.
