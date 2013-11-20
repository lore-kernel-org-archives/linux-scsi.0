From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 01/18] target core: rename (ex,im)plict -> (ex,im)plicit
Date: Wed, 20 Nov 2013 11:29:47 -0800
Message-ID: <1384975787.4307.65.camel@haakon3.risingtidesystems.com>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
	 <1384848483-3771-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384848483-3771-2-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-11-19 at 09:07 +0100, Hannes Reinecke wrote:
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_alua.c      | 110 ++++++++++++++++-----------------
>  drivers/target/target_core_alua.h      |  20 +++---
>  drivers/target/target_core_configfs.c  |  26 ++++----
>  drivers/target/target_core_device.c    |   6 +-
>  drivers/target/target_core_file.c      |   2 +-
>  drivers/target/target_core_pr.c        |  24 +++----
>  drivers/target/target_core_spc.c       |   6 +-
>  drivers/target/target_core_transport.c |   4 +-
>  drivers/target/target_core_ua.h        |   2 +-
>  include/target/target_core_base.h      |   2 +-
>  10 files changed, 101 insertions(+), 101 deletions(-)

Applied.  Thanks Hannes!

--nab
