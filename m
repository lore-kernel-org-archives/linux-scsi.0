From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [2.6 patch] scsi/qla2xxx/qla_os.c section fix
Date: Mon, 03 Dec 2007 06:18:01 -0800
Message-ID: <47541019.70302@qlogic.com>
References: <20071125220503.GF18284@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:43246 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbXLCOSD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2007 09:18:03 -0500
In-Reply-To: <20071125220503.GF18284@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> qla2x00_remove_one() mustn't be __devexit since it's called from 
> qla2xxx_pci_error_detected().
> 
> This patch fixes the following section mismatch:
> 
> <--  snip  -->
> 
> ...
> WARNING: vmlinux.o(.text+0x2a4462): Section mismatch: reference to .exit.text:qla2x00_remove_one (between 'qla2xxx_pci_error_detected' and 'qla2x00_stop_timer')
> ...
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
ACK.
Acked-by: Seokmann Ju <seokmann.ju@qlogic.com>
