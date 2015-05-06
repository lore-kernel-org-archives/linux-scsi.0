From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] drivers/scsi/arm/acornscsi.c: rename
 CONFIG_ACORNSCSI_CONSTANTS
Date: Wed, 6 May 2015 11:38:55 +0100
Message-ID: <20150506103855.GL2067@n2100.arm.linux.org.uk>
References: <1430230511-10869-1-git-send-email-valentinrothberg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430230511-10869-1-git-send-email-valentinrothberg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 28, 2015 at 04:15:11PM +0200, Valentin Rothberg wrote:
> CONFIG_ACORNSCSI_CONSTANTS is a file local CPP identifier and thereby
> violates the naming convention of Kconfig options in Make and CPP
> syntax; only Kconfig options should carry the 'CONFIG_' prefix.
> 
> This patch removes the 'CONFIG_' prefix to apply to this convention and
> to make static analysis tools happy.
> 
> Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>

As you're merely renaming all instances of this:

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
