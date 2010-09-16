From: Chetan Loke <chetanloke@gmail.com>
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand() caller
Date: Thu, 16 Sep 2010 19:26:40 -0400
Message-ID: <AANLkTi=QXj0Do_PDvFmu5v8Py_tm_uJdDh_PQu_96M2v@mail.gmail.com>
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56074 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0IPX0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2010 19:26:41 -0400
In-Reply-To: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>

On Thu, Sep 16, 2010 at 6:35 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:

> and LLDs have adopted over the years. =C2=A0The changes involved here=
 are really
> quite straight forward, but please note that none of this code has be=
en tested
> with actual hardware yet, and is intended for generating comments for=
 the relivent
> SCSI LLD driver maintainers and other interested folks.
>

NO. Why not try testing it w/ an abort storm first else we will
seriously end up screwing the filesystems....
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
