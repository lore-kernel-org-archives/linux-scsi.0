From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM TOPIC] blk-trace update vs API stability
Date: Wed, 4 Jan 2017 09:49:33 +0100
Message-ID: <62463a62-2dcb-639c-364c-3cc8b50628d2@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi all,

during investigating performance issues I frequently have the need to
include the request tag in the scsi tracepoints. While this can be
easily done for scsi, including it in block trace output is not that
easy due to the interdependency with the blktrace utilities.

Also there had been some discussion on KS last year, but with no
conclusive result IIRC.

At LSF I'd like to discuss
- Do we consider blktrace (and any other tracepoint in eg SCSI) as a
stable API?
- How do we go about modifying blktrace? Is this even desired?
  Or should any trace event modification be opaque to blktrace output?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
