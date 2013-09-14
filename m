From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH v2] SCSI: buslogic: Added check for DMA mapping errors (wasRe:[BusLogic] DMA-API: device driver failed to check map error)
Date: Sat, 14 Sep 2013 12:34:13 +0900
Message-ID: <201309141234.AGC35960.tVOMOOLJFQHFSF@I-love.SAKURA.ne.jp>
References: <1378816604.6973.53.camel@dabdike.int.hansenpartnership.com>
	<1379004807.10738.3.camel@concerto>
	<201309140042.GEI73439.QHSJtOFFVFOLOM@I-love.SAKURA.ne.jp>
	<52333560.50209@oracle.com>
	<1379101446.8358.4.camel@concerto>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1379101446.8358.4.camel@concerto>
Sender: linux-kernel-owner@vger.kernel.org
To: khalid.aziz@oracle.com
Cc: jbottomley@parallels.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Khalid Aziz wrote:
> Added check for DMA mapping errors for request sense data
> buffer. Checking for mapping error can avoid potential wild
> writes. This patch was prompted by the warning from
> dma_unmap when kernel is compiled with CONFIG_DMA_API_DEBUG.

This patch looks OK and works OK to me.

Thank you.
