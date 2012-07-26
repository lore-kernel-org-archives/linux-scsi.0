From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v3 0/7] ZPODD patches for scsi tree
Date: Thu, 26 Jul 2012 09:43:37 -0400
Message-ID: <50114989.3010900@pobox.com>
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Lin Ming <minggr@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 07/26/2012 06:05 AM, Aaron Lu wrote:
> v3:
> Rebase on top of scsi-misc tree;
> Add the sr related patches previously in Jeff's libata tree;
> Re-organize the sr patches.
> A problem for now: for patch
> scsi: sr: support zero power ODD(ZPODD)
> I can't set a flag in libata-acpi.c since a related function is
> missing in scsi-misc tree. Will fix this when 3.6-rc1 released.

What does this mean?  Would you be more specific?

	Jeff



