From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V4 00/11] megaraid_sas: Updates for scsi-next
Date: Tue, 6 Dec 2016 23:31:22 -0800
Message-ID: <20161207073122.GB26970@infradead.org>
References: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Cc: jejb@kernel.org, hch@infradead.org, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com
List-Id: linux-scsi@vger.kernel.org

This seems to be missing the pci_alloc_irq_vectors conversion from
Hannes?
