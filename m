From: =?UTF-8?Q?Dainius_Masili=C5=ABnas?= <pastas4@gmail.com>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Tue, 10 Jan 2017 20:44:54 +0000
Message-ID: <CABhjJhOp1GB0KXupWhDh-5v-+6N8=qA=rE9L21AANhdN5C0Bxg@mail.gmail.com>
References: <CABhjJhMN31Ooq5ewpBft97w2+UpYM8S_hkpgwWm3a0wBhXW14g@mail.gmail.com>
 <Pine.LNX.4.44L0.1701101520510.2462-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34102 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbdAJUoz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2017 15:44:55 -0500
In-Reply-To: <Pine.LNX.4.44L0.1701101520510.2462-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Tom Yan <tom.ty89@gmail.com>

(I pressed reply instead of reply to all, sorry. Resending this.)

On Tue, Jan 10, 2017 at 8:29 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> There _is_ a quirk for broken models.  However, we don't know how
> complete the set of quirk entries is, so we err on the side of caution.

Then what is it used for? There doesn't seem to be much point in a
blacklist when the functionality is disabled by default to begin with.

And if there's a whitelist, does it mean that we should submit the IDs
of working USB devices for whitelisting? Also, is there a module
parameter to toggle the functionality, to facilitate testing whether
the device works fine or not?
