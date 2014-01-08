From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] [SCSI] advansys: change buildtime warning into runtime
 error
Date: Wed, 08 Jan 2014 21:29:41 +0100
Message-ID: <1389212981.14754.21.camel@x220>
References: <1352113082.1434.31.camel@x61.thuisdomein>
	 <1359454842.1345.40.camel@x61.thuisdomein> <1389211514.14754.10.camel@x220>
	 <201401082115.28472.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201401082115.28472.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-01-08 at 21:15 +0100, Ondrej Zary wrote:
> The driver works fine with narrow boards. Please don't break working drivers 
> because of some stupid warning.

My patch changed a buildtime warning for both narrow and wide boards in
a runtime error on wide boards only. That wouldn't break the narrow
boards. (I happen to own neither a narrow nor a wide board.)

In seven years that buildtime warning has not resulted in a fix for wide
boards, has it? So at this point that warning is rather pointless.

Is anybody even using these wide boards?


Paul Bolle
