From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RESEND] [PATCH] [SCSI] libsas: Allow expander T-T attachments
Date: Thu, 22 Sep 2011 19:32:08 +0200
Message-ID: <CAO+b5-qC1e0TYSwa1mGg=zLkBQcH7KjbqxN1wOacruksnyoDPQ@mail.gmail.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com>
 <1316691000.10571.6.camel@dabdike> <1316709696.61028.YahooMailNeo@web31812.mail.mud.yahoo.com>
 <20110922165014.GA12505@infradead.org> <1316712267.95370.YahooMailNeo@web31801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab1IVRc3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2011 13:32:29 -0400
In-Reply-To: <1316712267.95370.YahooMailNeo@web31801.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, Sep 22, 2011 at 7:24 PM, Luben Tuikov <ltuikov@yahoo.com> wrote:
> I've noticed this recently as well. I'm not sure if it is Yahoo or Firefox, or my cutting and pasting from Emacs as opposed to Xterm.

A quote from commit 5ce9f07bf1bed9a1f9886373ad0b149294f84c25 (March 10, 2010):

<quote>
Gmail web gui does not work for sending patches now even with firefox
"view source with" extension.  It will use windows style line breaks to
wrap lines automatically when sening email.
[ ... ]
-The last problem is that Gmail will base64-encode any message that has a
-non-ASCII character.  That includes things like European names.  Be aware.
</quote>

It's not impossible that the same comments apply to Yahoo mail too.

Bart.
