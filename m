From: Kyle Moffett <kyle@moffetthome.net>
Subject: Re: [PATCH] target: Update copyright ownership to 2012
Date: Sat, 10 Nov 2012 16:18:16 -0800
Message-ID: <CAGZ=bqJ26Y2x9j+QuARAdfxSsU3ncSZV+YRU8ZiCvS6fSx=X_A@mail.gmail.com>
References: <1352502014-9782-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1352502014-9782-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, bkuhn@sfconservancy.org, Andy Grover <agrover@redhat.com>, Marc Fleischmann <mwf@risingtidesystems.com>, legal@lists.gpl-violations.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 9, 2012 at 3:00 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> This patch to update copyright year to current for principal target core
> ownership is now being pushed into target-pending/for-next.

Pardon me, but you were just publicly accused of violating the GPL, so
your response is to send a patch removing the copyright notices of all
other organizations from the SCSI-target code?  Have you obtained
ownership of all the relevant copyrights for Linux-iSCSI.org, PyX
Technologies, Inc, and SBE, Inc?  If not, then this patch is an
attempted violation of those organizations copyrights and of the GPL
(which requires that you preserve copyright notices).

Further, while these notices are the only ones listed in those files,
they are not the only individuals outside of RisingTide Systems which
have significant copyright interest in this code.  If your goal is to
obtain exclusive copyright ownership over this code then there are a
great many other people you must contact and convince first.

I would encourage you to talk privately with the Software Freedom
Conservancy before sending more patches of this nature.

Cheers,
Kyle Moffett

> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> - * Copyright (c) 2009-2010 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> - * Copyright (c) 2008-2011 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> - * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
> - * Copyright (c) 2005-2006 SBE, Inc.  All Rights Reserved.
> - * Copyright (c) 2008-2010 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> - * Copyright (c) 2010,2011 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
> - * Copyright (c) 2010 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> - * Copyright (c) 2005 PyX Technologies, Inc.
> - * Copyright (c) 2005-2006 SBE, Inc.  All Rights Reserved.
> - * Copyright (c) 2008-2010 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
> - * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
> - * Copyright (c) 2005, 2006, 2007 SBE, Inc.
> - * Copyright (c) 2008-2010 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> - * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
> - * Copyright (c) 2005, 2006, 2007 SBE, Inc.
> - * Copyright (c) 2008-2010 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> - * Copyright (c) 2009, 2010 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> - * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
> - * Copyright (c) 2005, 2006, 2007 SBE, Inc.
> - * Copyright (c) 2008-2010 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
> - * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
> - * Copyright (c) 2005, 2006, 2007 SBE, Inc.
> - * Copyright (c) 2008-2010 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> - * Copyright (c) 2002, 2003, 2004, 2005 PyX Technologies, Inc.
> - * Copyright (c) 2005, 2006, 2007 SBE, Inc.
> - * Copyright (c) 2008-2010 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> - * Copyright (c) 2002, 2003, 2004, 2005 PyX Technologies, Inc.
> - * Copyright (c) 2005, 2006, 2007 SBE, Inc.
> - * Copyright (c) 2008-2010 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
> - * Copyright (c) 2011 Linux-iSCSI.org
> - * Copyright (c) 2006-2007 SBE, Inc.  All Rights Reserved.
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> - * Copyright (c) 2009,2010 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> - * Copyright (c) 2002, 2003, 2004, 2005 PyX Technologies, Inc.
> - * Copyright (c) 2005, 2006, 2007 SBE, Inc.
> - * Copyright (c) 2008-2010 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> - * Copyright (c) 2002, 2003, 2004, 2005 PyX Technologies, Inc.
> - * Copyright (c) 2005, 2006, 2007 SBE, Inc.
> - * Copyright (c) 2008-2010 Linux-iSCSI.org
> diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
> - * Copyright (c) 2009,2010 Linux-iSCSI.org
