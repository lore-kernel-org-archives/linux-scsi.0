From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH v7 7/9] snic:Add sysfs entries to list stats and trace
 data
Date: Mon, 15 Jun 2015 04:18:18 +0000
Message-ID: <D1A44F99.27904%nmusini@cisco.com>
References: <1432886649-12034-1-git-send-email-nmusini@cisco.com>
 <1432886649-12034-8-git-send-email-nmusini@cisco.com>
 <1434212252.2208.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-7.cisco.com ([173.37.142.94]:3616 "EHLO
	alln-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbbFOESV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2015 00:18:21 -0400
In-Reply-To: <1434212252.2208.4.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <544621C20CEDB34BAF62B6FD9F4EA3AE@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "boaz@plexistor.com" <boaz@plexistor.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi James,=20

      Thanks for fixing the errors. the check patch that I used didn=B9=
t
list them as error, probably a lower version.

Thank you very much for mentoring.

Thanks
Narsimhulu

On 13/06/15 9:47 pm, "James Bottomley"
<James.Bottomley@HansenPartnership.com> wrote:

>On Fri, 2015-05-29 at 01:04 -0700, Narsimhulu Musini wrote:
>> +static const struct file_operations snic_stats_fops __read_mostly =3D=
 {
>> +	.owner	=3D THIS_MODULE,
>> +	.open	=3D snic_stats_open,
>> +	.read	=3D seq_read,
>> +	.llseek =3D seq_lseek,
>> +	.release =3D single_release,
>> +};
>
>Checkpatch hates this for obvious reasons: a const structure has to be
>read only, not read mostly, so it's a section conflict.  I fixed it up=
,
>but running the code through checkpatch would have flagged it as an
>error.
>
>James
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
