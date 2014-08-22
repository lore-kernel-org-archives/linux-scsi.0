From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH] drivers: scsi: #define missing include guards
Date: Fri, 22 Aug 2014 15:28:54 +0200
Message-ID: <87iolkslex.fsf@rasmusvillemoes.dk>
References: <1408711053-14129-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1408711053-14129-1-git-send-email-linux@rasmusvillemoes.dk>
	(Rasmus Villemoes's message of "Fri, 22 Aug 2014 14:37:33 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

> The four files aha1542.h, aha1740.h, gvp11.h and mvme147.h under
> drivers/scsi/ contain two-thirds of an include guard, but do not
> elsewhere.
>

Argh, git commit ate a line because it happened to start with #. This
was supposed to be something like "...but do not #define the macro. git
grep says that the macro names are not defined elsewhere."

Rasmus
