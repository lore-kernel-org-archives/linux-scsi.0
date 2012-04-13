From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: scsi: require help for one issue about INQUIRY?
Date: Fri, 13 Apr 2012 22:42:08 +0800
Message-ID: <CAEH94LgkT03amAG3GD-wcfEg+q6S0=h97JkJFwBgdhDTnj1yYg@mail.gmail.com>
References: <CAEH94LiE6-QqJowDm+nAT3-g_JOFKBfZ=AW5Thibq5AP93DVAg@mail.gmail.com>
	<1334328012.3028.37.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53067 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2DMOmJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Apr 2012 10:42:09 -0400
Received: by pbcun15 with SMTP id un15so3706999pbc.19
        for <linux-scsi@vger.kernel.org>; Fri, 13 Apr 2012 07:42:08 -0700 (PDT)
In-Reply-To: <1334328012.3028.37.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Apr 13, 2012 at 10:40 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2012-04-13 at 22:30 +0800, Zhi Yong Wu wrote:
>> HI,
>>
>> When one machine was started with one scsi device,the information
>> below was showed. Does anyone know how to fix this issue?
>>
>> "scsi scan: INQUIRY result too short (5), using 36"
>> "Scsi 2:0:292:0: Direct-Access"
>
> Well, it means what it says: the device wrongly returned only 5 bytes
"using 36" mean that device should return 36 bytes?
> for the INQUIRY command. =A0Why it did this is a hardware issue.
>
> James
>
>
>



--=20
Regards,

Zhi Yong Wu
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
