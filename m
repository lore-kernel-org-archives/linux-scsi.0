From: Denis Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 3/4] aic7xxx: remove excessive inlining
Date: Sun, 13 Aug 2006 15:03:07 +0200
Message-ID: <200608131503.07987.vda.linux@googlemail.com>
References: <200608131457.21951.vda.linux@googlemail.com> <200608131458.52804.vda.linux@googlemail.com> <200608131502.10664.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:40341 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S1751198AbWHMNDR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Aug 2006 09:03:17 -0400
Received: by py-out-1112.google.com with SMTP id z74so4242197pyg
        for <linux-scsi@vger.kernel.org>; Sun, 13 Aug 2006 06:03:17 -0700 (PDT)
In-Reply-To: <200608131502.10664.vda.linux@googlemail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

On Sunday 13 August 2006 15:02, Denis Vlasenko wrote:
> Basically, patches deinline some functions, mainly those
> which perform port I/O.

ahd_suspend/resume are not used. #ifdef them out.
--
vda
