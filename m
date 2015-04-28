From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] drivers/scsi/arm/acornscsi.c: rename
 CONFIG_ACORNSCSI_CONSTANTS
Date: Tue, 28 Apr 2015 21:10:24 +0200
Message-ID: <1430248224.2411.68.camel@x220>
References: <1430230511-10869-1-git-send-email-valentinrothberg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430230511-10869-1-git-send-email-valentinrothberg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: JBottomley@odin.com, linux@arm.linux.org.uk, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-04-28 at 16:15 +0200, Valentin Rothberg wrote:
> CONFIG_ACORNSCSI_CONSTANTS is a file local CPP identifier and thereby
> violates the naming convention of Kconfig options in Make and CPP
> syntax; only Kconfig options should carry the 'CONFIG_' prefix.
> 
> This patch removes the 'CONFIG_' prefix to apply to this convention and
> to make static analysis tools happy.

Will the Erlangen bot still spot ACORNSCSI_CONSTANTS as a potential
issue?


Paul Bolle
