From: Felipe W Damasio <felipewd@terra.com.br>
Subject: [PATCH] Memory leak in scsi_debug found by checker
Date: Tue, 23 Sep 2003 15:54:38 -0300
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F7096EE.8080105@terra.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

	Hi James,

	Patch against 2.6-test5.

	If in the middle of loop a kmalloc failed, that means that the 
previous calls succeeded..so they must be also be freed (and removed 
from the dev_info_list).

	Please review and consider applying.

	Cheers,

Felipe
