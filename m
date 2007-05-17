From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Asynchronous scsi scanning
Date: Thu, 17 May 2007 19:24:14 +0100
Message-ID: <20070517182414.GA12170@infradead.org>
References: <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com> <17841.simon.1179228389@5ec7c279.invalid> <20070515120228.GI10562@parisc-linux.org> <4649E03A.1090004@simon.arlott.org.uk> <20070515172905.GJ10562@parisc-linux.org> <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com> <20070516025121.GK10562@parisc-linux.org> <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com> <20070517172023.GL10562@parisc-linux.org> <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760732AbXEQSYq@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 17, 2007 at 11:11:10PM +0530, Satyam Sharma wrote:
> Another command to /proc/scsi/scsi isn't a bad thought at all, considering

Yes it is.  /proc/scsi/scsi is a horrible interface and deprecated since
the start of the 2.6 series.
