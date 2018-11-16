From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 0/3] SG_IO command filtering via sysfs
Date: Fri, 16 Nov 2018 10:17:19 -0800
Message-ID: <1542392239.100259.52.camel@acm.org>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
         <20181111131445.GB25441@infradead.org> <20181111134241.GA2447@thunk.org>
         <20181112082013.GA9307@infradead.org>
         <79d7d4b2-e9b3-00b4-2ad0-789888f7ee36@redhat.com>
         <20181116093225.GA17033@infradead.org>
         <fa3ed175-13a3-bedf-ebf9-ddf46a2decd5@redhat.com>
         <20181116174352.GH20617@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181116174352.GH20617@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-11-16 at 12:43 -0500, Theodore Y. Ts'o wrote:
+AD4 I'd argue that a purpose-built eBPF access control facility is
+AD4 superior to the security+AF8-file+AF8-ioctl() LSM hook because it can make
+AD4 available to the authorization function access to the cached results
+AD4 of the SCSI INQUIRY command, and it avoids needing to duplicate
+AD4 knowledge of how to parse the parameters of the SG+AF8-IO ioctl in the LSM
+AD4 module as well as in the SCSI stack.

If an eBPF program would decide which SG+AF8-IO commands will be executed
and which ones not, does that mean that a SCSI parser would have to be
implemented in eBPF? If so, does that mean that both the eBPF and the
LSM approach share the disadvantage of requiring to do SCSI CDB parsing
outside the SCSI core?

Bart.
