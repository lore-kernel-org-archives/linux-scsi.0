From: =?UTF-8?Q?Dainius_Masili=C5=ABnas?= <pastas4@gmail.com>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Tue, 10 Jan 2017 20:09:50 +0000
Message-ID: <CABhjJhMN31Ooq5ewpBft97w2+UpYM8S_hkpgwWm3a0wBhXW14g@mail.gmail.com>
References: <201701102031.42361@pali> <Pine.LNX.4.44L0.1701101457390.2462-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:35910 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965422AbdAJUJv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2017 15:09:51 -0500
In-Reply-To: <Pine.LNX.4.44L0.1701101457390.2462-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Tom Yan <tom.ty89@gmail.com>

Huh, intersting to know. Why would they die on 16 and not on 10? Also,
wouldn't the right way to handle it be to use a quirk for broken
models, then? Since my disk seems to work fine in that regard.
