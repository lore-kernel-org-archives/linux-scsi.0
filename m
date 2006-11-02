From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 3/8] cciss: change number of commands per controller
Date: Thu, 2 Nov 2006 15:11:50 +0100
Message-ID: <20061102141149.GI13555@kernel.dk>
References: <20061101215640.GC29928@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:41818 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S1752898AbWKBOJ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2006 09:09:59 -0500
Content-Disposition: inline
In-Reply-To: <20061101215640.GC29928@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Nov 01 2006, Mike Miller (OS Dev) wrote:
> +	{0x3211103C, "Smart Array E200i", &SA5_access, 120},

Is it 120, or 128? And how big is the allocated command array now, with
512 commands?

-- 
Jens Axboe

