From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] mvsas: use correct named constants
Date: Mon, 29 Oct 2012 11:39:15 +0100
Message-ID: <1351507155.1339.10.camel@x61.thuisdomein>
References: <1348229466.1581.21.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348229466.1581.21.camel@x61.thuisdomein>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-09-21 at 14:11 +0200, Paul Bolle wrote:
> Building the mvsas driver triggers these GCC warnings:
>     drivers/scsi/mvsas/mv_sas.c:1156:34: warning: comparison between 'enum sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]
>     drivers/scsi/mvsas/mv_sas.c:1159:39: warning: comparison between 'enum sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]
> 
> Silence these warnings by using the named constants from enum
> sas_device_type with the same value as the currently used named
> constants.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) I noticed these warnings while building v3.6-rc6 on current Fedora
> 17, using Fedora's default config.

Identical warnings can be seen while building v3.7-rc3. What's the
status of my patch? Did anyone found some time to have a look at it?


Paul Bolle
