From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 2/2] virtio-scsi: add error handling
Date: Sun, 11 Mar 2012 13:47:11 +0100
Message-ID: <4F5C9ECF.8060803@redhat.com>
References: <1324296188-3426-1-git-send-email-pbonzini@redhat.com> <1324296188-3426-3-git-send-email-pbonzini@redhat.com> <20120310084806.GB24958@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62412 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2CKMrP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Mar 2012 08:47:15 -0400
In-Reply-To: <20120310084806.GB24958@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hu Tao <hutao@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>

Il 10/03/2012 09:48, Hu Tao ha scritto:
> Is there a race here that the cmd may have been already freed (by
> virtscsi_complete_free) after waking up from the completion?

Looks right, can you submit with a Signed-off-by?

Paolo
