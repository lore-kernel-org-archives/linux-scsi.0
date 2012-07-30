From: Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH SCSI] sr: check_events() ignore GET_EVENT when TUR says otherwise
Date: Mon, 30 Jul 2012 21:41:29 +0200
Message-ID: <CAPXgP11xSaPnhO2xuXKSqar+k_PCxftgnRZiRjL=0ucFMe_fVw@mail.gmail.com>
References: <20110630130348.GQ3386@htj.dyndns.org> <20110720163308.GC9924@mtj.dyndns.org>
 <CAPXgP11R=386wbqpOpymzdXYYhpvJg9Aj1Xck3wi91smud-8iA@mail.gmail.com>
 <1311180316.8570.1.camel@mulgrave> <CAOcK=CMPjZGNMiPS9LJMG6=t7sbLxjSkTikwRL2nhq6tewfofQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41145 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab2G3Tlu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2012 15:41:50 -0400
Received: by pbbrp8 with SMTP id rp8so10315381pbb.19
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jul 2012 12:41:49 -0700 (PDT)
In-Reply-To: <CAOcK=CMPjZGNMiPS9LJMG6=t7sbLxjSkTikwRL2nhq6tewfofQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Markus Rathgeb <maggu2810@googlemail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org

On Mon, Jul 30, 2012 at 9:06 PM, Markus Rathgeb
<maggu2810@googlemail.com> wrote:
> Hello!
>
> Do you remember?
> I get it again, is there something I could do?
>
> I attached a file that contains the "udevadm monitor" log.
>
> I am using a v3.5.0 linux kernel (containing some gentoo patches).
> Should I test it with a vanilla one?

I have 3.5 here and see the loop too, but it stops after a couple of seconds:

first: KERNEL[15636.368034]
last: KERNEL[15638.879796]

The kernel log says:
[15634.066481] sr 13:0:0:1: GET_EVENT and TUR disagree continuously,
suppress GET_EVENT events

Kay
