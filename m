From: Marc Bejarano <beej@beej.org>
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
Date: Mon, 11 Jan 2010 11:41:35 -0800
Message-ID: <5543f88f1001111141r5375d2a3kd726d2b70e124b94@mail.gmail.com>
References: <5543f88f1001111129u362be554kd97027d977b5dff3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753995Ab0AKTll@vger.kernel.org>
In-Reply-To: <5543f88f1001111129u362be554kd97027d977b5dff3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

and once more in plain text. =A0(sorry vger)

2010/1/11 Marc Bejarano <beej@beej.org>:
> oops. =A0seems that GMANE's reply function only goes to a single "new=
sgroup".
> =A0original recipients re-added.
> marc
> ----
> From: Marc Bejarano <beej <at> beej.org>
> Subject:=A0Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
> Newsgroups:=A0gmane.linux.scsi
> Date: 2010-01-08 22:21:09 GMT (2 days, 20 hours and 40 minutes ago)
>
> Ren=E9 Bolldorf <xsecute <at> googlemail.com> writes:
>> On 01/08/10 16:28, James Bottomley wrote:
>> > On Thu, 2010-01-07 at 14:15 -0500, Jeff Garzik wrote:
>> >> On 12/30/2009 05:59 PM, Ren=E9 Bolldorf wrote:
>> >>> We don't need this .
>
>> >>> - /* FIXME: is this needed? */
>> >>> - memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
>> >>
>> >> I need a little bit more detail than an unqualified statement... =
=A0Did
>> >> you audit all paths leading to this code point?
>
>> > But one also here:
>> >
>> > u8 *sense_buffer =3D dev->link->ap->sector_buf;
>> > [...]
>> > err_mask =3D atapi_eh_request_sense(dev, sense_buffer, sense_key);
>> >
>> > Which doesn't look OK because it looks like the sector_buf isn't c=
leared
>> > (and it is reused).
>> >
>> > James
>> >
>> >
>>
>> Thank's, you're right. I have overseen this, sry for that.
>
> Ren=E9: perhaps you'd like to submit a patch that substitutes FIXME c=
omment
> for one that explains why the memset is needed, crediting James in th=
e
> description? =A0we may as well gain something permanent from this dis=
cussion
> that you started :)
>
> cheers,
> marc
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> ----
