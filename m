From: Thunder from the hill <thunder@lightweight.ods.org>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: Wed, 4 Sep 2002 13:34:25 -0600 (MDT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209041333260.3373-100000@hawkeye.luckynet.adm>
References: <20020904182505.B20614@bitwizard.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20020904182505.B20614@bitwizard.nl>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andries Brouwer <aebr@win.tue.nl>, James Bottomley <James.Bottomley@steeleye.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On Wed, 4 Sep 2002, Rogier Wolff wrote:
> I will most likely set the "retry count" to 0: Never retry. Almost
> never works anyway. And the disk already retried manytimes, so
> retrying in software is only "taking time".

fd = open(pathname, O_NORETRY); ?

			Thunder
-- 
--./../...-/. -.--/---/..-/.-./..././.-../..-. .---/..-/.../- .-
--/../-./..-/-/./--..-- ../.----./.-../.-.. --./../...-/. -.--/---/..-
.- -/---/--/---/.-./.-./---/.--/.-.-.-
--./.-/-.../.-./.././.-../.-.-.-
