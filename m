From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: Resolve some missing-field-initializers warnings
Date: Sat, 18 Oct 2014 08:15:17 -0700
Message-ID: <20141018151517.GE30355@infradead.org>
References: <1413293933-31164-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20141017132611.GM16538@infradead.org>
 <C69957AC-DB35-467C-85B1-091B740C74C9@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C69957AC-DB35-467C-85B1-091B740C74C9@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 17, 2014 at 10:44:36PM +0000, Rustad, Mark D wrote:
> The warning appears in W=2 builds. I had another way to silence it by using diagnostic control macros, but those macros were not accepted. Using a single designated initialization also silences it.


Oh well.  I think the earlier version was slightly cleaner, but if it
helps people to catch real bugs better I'm happy to apply it.
