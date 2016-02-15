From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [RFC 20/34] iscsi-target: update struct iscsit_transport
 definition
Date: Mon, 15 Feb 2016 19:09:55 +0200
Message-ID: <56C20663.8010405@dev.mellanox.co.il>
References: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
 <a7968adffc57ab25f06713890159014b3571bc53.1455467089.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34542 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbcBORJ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2016 12:09:59 -0500
Received: by mail-wm0-f46.google.com with SMTP id b205so76054950wmb.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2016 09:09:58 -0800 (PST)
In-Reply-To: <a7968adffc57ab25f06713890159014b3571bc53.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com


> 1. void (*iscsit_rx_pdu)(struct iscsi_conn *);
>     Rx thread uses this for receiving and processing
>     iSCSI PDU in full feature phase.

Is iscsit_rx_pdu the best name for this? it sounds like
a function that would handle A pdu, but it's actually the
thread function dequeuing pdus correct?
