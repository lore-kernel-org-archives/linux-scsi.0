From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC] How to fix an async scan - 'rmmod --wait' race?
Date: Fri, 25 May 2012 11:46:19 -0700
Message-ID: <CAA9_cmd1DF_SxJOjzZj9zFEzsbOQuq+7KQAJ56SvOuRLC-QwDQ@mail.gmail.com>
References: <4F7DA4F8.90104@redhat.com>
	<4F86CF34.2000906@redhat.com>
	<4F8EF05F.8080307@redhat.com>
	<1337244177.2926.21.camel@dabdike.int.hansenpartnership.com>
	<4FB4BCEB.60506@acm.org>
	<1337245278.30498.2.camel@dabdike.int.hansenpartnership.com>
	<4FB51086.3060406@redhat.com>
	<1337681133.2932.4.camel@dabdike.int.hansenpartnership.com>
	<4FBFA18E.9040904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52719 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430Ab2EYSqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 May 2012 14:46:20 -0400
Received: by gglu4 with SMTP id u4so1070259ggl.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 May 2012 11:46:19 -0700 (PDT)
In-Reply-To: <4FBFA18E.9040904@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Mike Christie <mchristi@redhat.com>, stefanr@s5r6.in-berlin.de

On Fri, May 25, 2012 at 8:13 AM, Tomas Henzl <thenzl@redhat.com> wrote:
> May 25 04:25:54 localhost kernel: [ =A0461.525209] BUG: unable to han=
dle kernel NULL pointer dereference at 0000000000000079
> May 25 04:25:54 localhost kernel: [ =A0461.525242] IP: [<ffffffff811f=
0c45>] sysfs_create_dir+0x35/0xc0

Have a look at:

http://marc.info/?l=3Dlinux-scsi&m=3D133793175125892&w=3D2

=2E..it addresses tearing down targets before they are added which
appears to be the signature here.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
