From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [patch] NCR5380.c fix
Date: 15 May 2003 17:52:06 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1053039127.3998.23.camel@mulgrave>
References: <UTC200305152245.h4FMjAj26766.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <UTC200305152245.h4FMjAj26766.aeb@smtp.cwi.nl>
To: Andries.Brouwer@cwi.nl
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, torvalds@transmeta.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2003-05-15 at 17:45, Andries.Brouwer@cwi.nl wrote:
> -					else if (cmd->SCp.Status != GOOD)
> +					else if (status_byte(cmd->SCp.Status) != GOOD)

Well...if we're doing it this way, any reason not to use the newly
minted SAM_STAT_GOOD and SAM_STAT_CHECK_CONDITION?

James
