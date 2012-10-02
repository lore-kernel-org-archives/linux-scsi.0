From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] target: Add target_submit_cmd_map_mem and convert
 tcm_loop+tcm_vhost
Date: Tue, 2 Oct 2012 11:22:19 -0400
Message-ID: <20121002152219.GD21786@infradead.org>
References: <1349162147-29098-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1349162147-29098-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This should also grow a patch 5 to unexport
transport_generic_map_mem_to_cmd and mark it static.
