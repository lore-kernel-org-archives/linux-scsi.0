From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v2 1/4] PHY: Add function set_speed to generic PHY framework
Date: Wed, 20 Nov 2013 22:06:57 +0400
Message-ID: <528CFA41.7020207@cogentembedded.com>
References: <1384905197-3566-1-git-send-email-lho@apm.com> <1384905197-3566-2-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:61797 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3KTSHP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2013 13:07:15 -0500
Received: by mail-lb0-f169.google.com with SMTP id y6so2183994lbh.0
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2013 10:07:14 -0800 (PST)
In-Reply-To: <1384905197-3566-2-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>, olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com

Hello.

On 20=11-2013 3:53, Loc Ho wrote:

> PHY: Add function set_speed to generic PHY framework

    There's no need to duplicate the subject in the changelog verbatim.

> This patch adds function set_speed to the generic PHY
> framework operation structure. This function can be
> called to instruct the PHY underlying layer at specified
> lane to configure for specified speed in hertz.

> Signed-off-by: Loc Ho <lho@apm.com>

WBR, Sergei

