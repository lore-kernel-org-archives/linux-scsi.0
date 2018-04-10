From: Jaco Kroon <jaco@uls.co.za>
Subject: Re: *** SPAM *** Re: [RFC PATCH] mpt3sas:
 mpt3sas_scsih_enclosure_find_by_handle can be static
Date: Tue, 10 Apr 2018 09:15:11 +0200
Message-ID: <8be1199e-01bd-6fb3-7da5-4a488442331e@uls.co.za>
References: <1521540956-42347-1-git-send-email-chaitra.basappa@broadcom.com>
 <20180320210652.GA40906@xian>
 <289588bbff4dc0d35e519d0c4d4282da78cc6121.camel@wdc.com>
 <yq1370jj278.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq1370jj278.fsf@oracle.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "lkp@intel.com" <lkp@intel.com>, "kbuild-all@01.org" <kbuild-all@01.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Martin, Bart,

I've not seen additional feedback on this (I may simply not be CCed).

I've applied the patch to one of our hosts where we've had endless IO
lockups (with MQ enabled the host died within a day or two, sometimes
sub one hour, without it typically ran for about two weeks).  With this
patch (on top of 4.16) we're now at four days and 17 hours, with IO
still going strong (including a mdadm reshape to add a disk, as well as
a rebuild on a drive that failed - concurrently on two different arrays,
same controller).  Very subjective, but the host also feels more
responsive under heavy IO load.

What can I do from my side (I've got some development experience) to
help push this patch forward?

Kind Regards,
Jaco


On 28/03/2018 23:54, Martin K. Petersen wrote:
> Bart,
>
>> Are you aware that if the 0-day test infrastructure suggests an improvement
>> for a patch that the patch that that improvement applies to gets ignored
>> unless either the patch is reposted with the improvement applied or that it
>> is explained why the suggested improvement is inappropriate?
> Correct. I don't apply anything that causes a 0-day warning. The patch
> will be closed with "Changes Required" status in patchwork.
>
> Always build patch submissions to linux-scsi with:
>
> 	make C=1 CF="-D__CHECK_ENDIAN__"
>
