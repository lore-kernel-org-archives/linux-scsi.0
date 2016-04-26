From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 03/12] scsi_debug: replace jiffy timers with hr timers
Date: Tue, 26 Apr 2016 11:38:44 -0700
Message-ID: <571FB5B4.6070603@sandisk.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
 <1461600999-28893-4-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0087.outbound.protection.outlook.com ([207.46.100.87]:21623
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753169AbcDZSiu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 14:38:50 -0400
In-Reply-To: <1461600999-28893-4-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 04/25/2016 09:16 AM, Douglas Gilbert wrote:
> -				if (sdebug_ndelay > 0) {
> +				if ((sdebug_delay > 0) ||
> +				    (sdebug_ndelay > 0)) {
> [ ... ]
> -				if (sdebug_ndelay > 0) {
> +				if ((sdebug_delay > 0) ||
> +				    (sdebug_ndelay > 0)) {
> [ ... ]
> +	if ((delta_jiff > 0) || (sdebug_ndelay > 0)) {

Please do not introduce superfluous parentheses since this makes the 
code unnecessarily hard to read. Otherwise this patch looks fine to me.

Bart.
