From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 11/11]: megaraid_sas: Documentation/scsi/ChangeLog.megaraid_sas
 update
Date: Tue, 21 Dec 2010 11:05:17 -0800
Message-ID: <AANLkTim2tQH59OMNAF83wjg4qhyxBFBfaYP7u=XicoF3@mail.gmail.com>
References: <AANLkTikKhNaBpxLiwENzEL+LkFdG+bnbpxv41MhNixb-@mail.gmail.com>
	<1292957932.3034.17.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64565 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0LUTFS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Dec 2010 14:05:18 -0500
Received: by qyj19 with SMTP id 19so5596439qyj.19
        for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2010 11:05:17 -0800 (PST)
In-Reply-To: <1292957932.3034.17.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On Tue, Dec 21, 2010 at 10:58 AM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Tue, 2010-12-14 at 19:11 -0800, adam radford wrote:
>> James/Linux-scsi,

> now something in 6-11 doesn't work:

James,

I sent an updated patch 7 and patch 10 earlier to fix the stack usage
issue found by Tomas Henzl.

They are here:

http://marc.info/?l=linux-scsi&m=129253119325399&w=2
http://marc.info/?l=linux-scsi&m=129253147225758&w=2

It looks like you picked up the new patch 7, but not the new patch 10.

I will re-send patches 6 thru 10 in a single patch.

-Adam
