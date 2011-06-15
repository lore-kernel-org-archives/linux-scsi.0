From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] target: Make transport_lookup_cmd_lun() locking IRQ-safe
Date: Wed, 15 Jun 2011 12:41:04 -0700
Message-ID: <BANLkTimxM4OzQ6imbea0xqb3rmfBehfgEA@mail.gmail.com>
References: <1308023045-5257-1-git-send-email-roland@kernel.org>
 <1308157596.20109.28.camel@haakon2.linux-iscsi.org> <BANLkTimM-=fGphT_okWuMYY1LgDk=XQzow@mail.gmail.com>
 <1308158714.20109.33.camel@haakon2.linux-iscsi.org> <4DF8F163.6010103@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45632 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1FOTlZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2011 15:41:25 -0400
In-Reply-To: <4DF8F163.6010103@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiran Patil <kiran.patil@intel.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Wed, Jun 15, 2011 at 10:52 AM, Kiran Patil <kiran.patil@intel.com> wrote:
> Likewise, we need to do same change in function "transport_get_lun_for_tmr",
> specifically for tmr_lock. Please correct me if I am missing anything.

Yes, that's right... in fact that is what we were discussing now, isn't it?
Or is there something different I'm missing?

(BTW transport_get_lun_for_tmr is renamed to transport_lookup_tmr_lun
in the latest tree)

 - R.
