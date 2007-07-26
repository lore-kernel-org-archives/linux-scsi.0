From: Meelis Roos <mroos@linux.ee>
Subject: Re: [PATCH v2] Remove libsas PCI dependencies
Date: Thu, 26 Jul 2007 20:31:31 +0300 (EEST)
Message-ID: <Pine.SOC.4.64.0707262030090.1921@math.ut.ee>
References: <Pine.SOC.4.64.0707261129220.17385@math.ut.ee>  <46A867AB.7050007@garzik.org>
 <1185454007.3501.34.camel@localhost.localdomain> <46A8A185.7010609@garzik.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934387AbXGZRb7@vger.kernel.org>
In-Reply-To: <46A8A185.7010609@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

> Eliminate unnecessary PCI dependencies in libsas.  It should use generic DMA
> and struct device like other subsystems.

Compiles fine, unfortunately I can not test kernels on this machine 
since I have yet to dig out the reason my kernels do not boot.

-- 
Meelis Roos (mroos@linux.ee)
