From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2.5.59] sim710: cleanup/remove most cli()'s
Date: Fri, 7 Feb 2003 08:26:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200302070826.25941@bilbo.math.uni-mannheim.de>
References: <200302041123.06204@bilbo.math.uni-mannheim.de> <200302051603.48510@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200302051603.48510@bilbo.math.uni-mannheim.de>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From James Bottomley:

> On Wed, 2003-02-05 at 09:03, Rolf Eike Beer wrote:

>> I'm now looking for the best way to port this to use 53c700.c. This will
>> surely take a while, should I fix my fix and resend it or better leave this
>> unfixed until I find time to port it?

> Do you actually have one of these (and is it EISA or MCA)?

It's a Compaq Prosignia with one onboard and the other one on an EISA card, 
using base addresses 0x8000 and 0x7000.

> I've got a MCA 710 in an old NCR3430 I can use.  I think the conversion
> will only take a few days, I can try it out

That would be fine, you know your code better than I ever will.

Eike
