From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 RESEND_2] scsi: report 'INQUIRY result too short' once
 per host
Date: Thu, 19 Nov 2015 05:37:18 -0800
Message-ID: <20151119133718.GA7884@infradead.org>
References: <1447939026-25306-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447939026-25306-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Hannes Reinecke <hare@suse.de>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

This looks like a good compromise:

Reviewed-by: Christoph Hellwig <hch@lst.de>
