From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH v3 0/4]: block layer runtime pm
Date: Wed, 23 May 2012 11:03:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205231103030.1566-100000@iolanthe.rowland.org>
References: <CAF1ivSZuedC-WH1cduhLFwHnCa9d7YVFnWw_7YZ8id9v50Af7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSZuedC-WH1cduhLFwHnCa9d7YVFnWw_7YZ8id9v50Af7g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 23 May 2012, Lin Ming wrote:

> Another thing need to check is if system suspend/resume works.

Right!  Although I would hope that your work doesn't interfere at all 
with system sleep, since it touches only the runtime PM pathways.

Alan Stern
