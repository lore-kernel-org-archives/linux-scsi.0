From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata & scsi rescan.
Date: Thu, 07 Oct 2004 18:26:48 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <4165C2A8.60001@pobox.com>
References: <415DA2C0.3060600@pobox.com> <20041001141244.B23006@florence.linkmargin.com> <415DB03E.5090005@pobox.com> <20041004155647.A9589@florence.linkmargin.com> <4161BB01.5080607@pobox.com> <20041006173656.A18221@florence.linkmargin.com> <416496CC.4090105@pobox.com> <20041006214746.A18793@florence.linkmargin.com> <4164B548.7030700@pobox.com> <4164BDD6.6000404@pobox.com> <20041007171457.B21662@florence.linkmargin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20041007171457.B21662@florence.linkmargin.com>
To: Andy Warner <andyw@pobox.com>
Cc: linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Also, to avoid scsi_device_lookup(), it may be nice to cache struct 
scsi_device pointer in struct ata_device.

	Jeff



