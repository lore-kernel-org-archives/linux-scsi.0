From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: mpt2sas logged messages
Date: Wed, 19 Aug 2009 21:30:11 +0200
Message-ID: <ac3eb2510908191230r7687ba34k4b8f6987ffa97ab8@mail.gmail.com>
References: <4A8AAA26.9090706@redhat.com> <20090818132518.GA4418@kroah.com>
	<4A8AB3DC.4060805@redhat.com> <20090818145710.GA6064@kroah.com>
	<4A8ACE7C.5080501@redhat.com> <20090818164017.GA24305@kroah.com>
	<ac3eb2510908181137ne79d4d7he1731d240bca614c@mail.gmail.com>
	<4A8AF5E4.7000806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.211.173]:48679 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbZHSTaZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Aug 2009 15:30:25 -0400
Received: by ywh3 with SMTP id 3so159355ywh.22
        for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2009 12:30:26 -0700 (PDT)
In-Reply-To: <4A8AF5E4.7000806@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tom Coughlan <coughlan@redhat.com>

On Tue, Aug 18, 2009 at 20:41, Ric Wheeler<rwheeler@redhat.com> wrote:

> I think that we can reconfigure the storage to avoid this but will be happy
> to restore this configuration if you have something that you want to test
> later on...

This hopefully addresses the issue:
  http://git.kernel.org/?p=linux/hotplug/udev.git;a=commit;h=2ffc9cc1917b1bb6fe86881a94a47dce9aa15168

Thanks,
Kay
