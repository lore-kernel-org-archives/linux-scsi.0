From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 05/16] iscsi-target: add void (*iscsit_get_rx_pdu)()
Date: Sun, 10 Apr 2016 20:43:59 +0300
Message-ID: <570A90DF.5040609@grimberg.me>
References: <cover.1460204441.git.varun@chelsio.com>
 <a454b4444bda97b5d36b6ba02fa492f401096036.1460204441.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36084 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbcDJRoD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2016 13:44:03 -0400
In-Reply-To: <a454b4444bda97b5d36b6ba02fa492f401096036.1460204441.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com


> Add void (*iscsit_get_rx_pdu)() to
> struct iscsit_transport, iscsi-target
> uses this callback to receive and
> process Rx iSCSI PDUs.

Same comment on change logs.

The iser bit looks harmless

Acked-by: Sagi Grimberg <sai@grimber.me>

Though I agree with hch that we don't really need
rx threads in iSER, but that's another story...
