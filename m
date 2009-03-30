From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [Scst-devel] ISCSI-SCST performance (with also IET and STGT data)
Date: Mon, 30 Mar 2009 20:53:58 +0200
Message-ID: <e2e108260903301153x38e86097vd29c47507da2879f@mail.gmail.com>
References: <49D10256.8030307@vlnb.net>
	 <e2e108260903301106y2b750c23kfab978567f3de3a0@mail.gmail.com>
	 <49D11096.3070804@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36297 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZC3SyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Mar 2009 14:54:01 -0400
In-Reply-To: <49D11096.3070804@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, iscsitarget-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, stgt@vger.kernel.org

On Mon, Mar 30, 2009 at 8:33 PM, Vladislav Bolkhovitin <vst@vlnb.net> w=
rote:
> Bart Van Assche, on 03/30/2009 10:06 PM wrote:
>> These are indeed interesting results. There are some aspects of the
>> test setup I do not understand however:
>> * All tests have been run with buffered I/O instead of direct I/O
>> (iflag=3Ddirect / oflag=3Ddirect). My experience is that the results=
 of
>> tests with direct I/O are easier to reproduce (less variation betwee=
n
>> runs). So I have been wondering why the tests have been run with
>> buffered I/O instead ?
>
> Real applications use buffered I/O, hence it should be used in tests.=
 It
> =A0evaluates all the storage stack on both initiator and target as a =
whole.
> The results are very reproducible, variation is about 10%.

Most applications do indeed use buffered I/O. Database software
however often uses direct I/O. It might be interesting to publish
performance results for both buffered I/O and direct I/O. A quote from
the paper "Asynchronous I/O Support in Linux 2.5" by Bhattacharya e.a.
(Linux Symposium, Ottawa, 2003):

Direct I/O (raw and O_DIRECT) transfers data between a user buffer and
a device without copying the data through the kernel=92s buffer cache.
This mechanism can boost performance if the data is unlikely to be
used again in the short term (during a disk backup, for example), or
for applications such as large database management systems that
perform their own caching.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
