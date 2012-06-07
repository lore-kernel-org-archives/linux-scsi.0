From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH 4/6] bnx2fc: Improve error recovery by handling
 parity errors
Date: Thu, 7 Jun 2012 01:39:04 -0700
Message-ID: <4FD068A8.7070305@broadcom.com>
References: <1338851747-7240-1-git-send-email-bprakash@broadcom.com>
 <1338851747-7240-5-git-send-email-bprakash@broadcom.com>
 <1339038209.26595.2.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3832 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487Ab2FGIjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jun 2012 04:39:18 -0400
In-Reply-To: <1339038209.26595.2.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

On 6/6/2012 8:03 PM, James Bottomley wrote:
> On Mon, 2012-06-04 at 16:15 -0700, Bhanu Prakash Gollapudi wrote:
>> @@ -321,6 +332,9 @@ static void bnx2fc_upload_session(struct fcoe_po=
rt *port,
>>
>>   		del_timer_sync(&tgt->upld_timer);
>>
>> +	} else if (test_bit(BNX2FC_FLAG_DISABLE_FAILED,&tgt->flags))
>> +		printk(KERN_ERR PFX "ERROR!! DISABLE req failed, destroy"
>> +				" not sent to FW\n");
>>   	} else
>>   		printk(KERN_ERR PFX "ERROR!! DISABLE req timed out, destroy"
>>   				" not sent to FW\n");
>
> You didn't actually compile this did you?  That else if has to have a=
n
> opening brace to match the closing one on the next else ...

My bad. I fixed this compilation error, but by mistake I applied that=20
change to next patch. I'll correct it and submit the last three patches=
=20
shortly, as you've already picked up the first three.

Thanks,
Bhanu

>
> James
>
> =13=EF=BF=BD=EF=BF=BD=EC=B9=BB=1C=EF=BF=BD&=EF=BF=BD~=EF=BF=BD&=EF=BF=
=BD=18=EF=BF=BD=EF=BF=BD+-=EF=BF=BD=EF=BF=BD=DD=B6=17=EF=BF=BD=EF=BF=BD=
w=EF=BF=BD=EF=BF=BD=CB=9B=EF=BF=BD=EF=BF=BD=EF=BF=BDm=EF=BF=BDb=EF=BF=BD=
=EF=BF=BDlr=C8=A2=EF=BF=BD=EF=BF=BD^n=EF=BF=BDr=EF=BF=BD=EF=BF=BD=EF=BF=
=BDz=EF=BF=BD=1A=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
&=EF=BF=BD=EF=BF=BD=1E=EF=BF=BDG=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=03=
(=EF=BF=BD=E9=9A=8E=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD=1A=EF=BF=BD=1Bm=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=BF=BD=DE=96=EF=BF=BD=EF=BF=
=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD~=EF=
=BF=BDm=EF=BF=BD


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
