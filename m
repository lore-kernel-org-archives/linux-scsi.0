From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 2/3] smartpqi: cleanup raid map warning message
Date: Fri, 29 Sep 2017 14:08:27 +0200
Message-ID: <5a063970-da16-367b-2fc9-38963cddba20@redhat.com>
References: <150654770573.11494.168365142464423047.stgit@brunhilda>
 <150654780575.11494.9545979297048993619.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751091AbdI2MIc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Sep 2017 08:08:32 -0400
In-Reply-To: <150654780575.11494.9545979297048993619.stgit@brunhilda>
Content-Language: en-MW
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

On 27.9.2017 23:30, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microsemi.com>
>
> Fix a small cosmetic bug in a very rarely encountered
> error message that can occur when a LD has a corrupted
> raid map.
>
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
