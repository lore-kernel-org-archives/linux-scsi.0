From: rob@osinvestor.com (Rob Radez)
Subject: Re: [PATCH] scsi_error fix
Date: Thu, 6 Mar 2003 20:09:46 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030307010946.GA18991@osinvestor.com>
References: <UTC200303062337.h26Nbv714178.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <UTC200303062337.h26Nbv714178.aeb@smtp.cwi.nl>
To: Andries.Brouwer@cwi.nl
Cc: torvalds@transmeta.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 07, 2003 at 12:37:57AM +0100, Andries.Brouwer@cwi.nl wrote:
> Below:
> scsi_error.c: apart from similar trivialities the only change:
> 
>     If a command fails (e.g. because it belongs to a newer
>     SCSI version than the device), it is fed to
>     scsi_decide_disposition(). That routine must return
>     SUCCESS, unless the error handler should be invoked.
[snip patch]

This patch gets me booting again.

Regards,
Rob Radez
